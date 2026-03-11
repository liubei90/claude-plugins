import express from "express";
import { createProxyMiddleware } from "http-proxy-middleware";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 8080;

const logsDir = path.join(__dirname, "../logs");
if (!fs.existsSync(logsDir)) {
  fs.mkdirSync(logsDir, { recursive: true });
}

const TARGET_URL = "https://ark.cn-beijing.volces.com";
const targetHost = new URL(TARGET_URL).host;

let requestCount = 0;
// 新增：生成带毫秒的时间戳（格式：YYYYMMDDHHmmssSSS）
const getFormattedTimestamp = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, "0");
  const day = String(date.getDate()).padStart(2, "0");
  const hours = String(date.getHours()).padStart(2, "0");
  const minutes = String(date.getMinutes()).padStart(2, "0");
  const seconds = String(date.getSeconds()).padStart(2, "0");
  const ms = String(date.getMilliseconds()).padStart(3, "0");
  return `${year}${month}${day}${hours}${minutes}${seconds}${ms}`;
};
// 新增：生成8位短唯一ID（数字+大小写字母）
const generateShortId = () => {
  // 字符库：0-9 + a-z + A-Z，共62个字符
  const chars =
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  let shortId = "";
  for (let i = 0; i < 8; i++) {
    // 随机取字符库中的字符
    const randomIndex = Math.floor(Math.random() * chars.length);
    shortId += chars[randomIndex];
  }
  return shortId;
};

function formatHeadersToText(headers) {
  // 检查输入是否为有效对象
  if (!headers || typeof headers !== "object" || Array.isArray(headers)) {
    return "";
  }

  // 转换 headers 为数组并格式化
  return Object.entries(headers)
    .map(([key, value]) => {
      // 处理多值 header（如 set-cookie 是数组）
      const formattedValue = Array.isArray(value)
        ? value.join("; ")
        : String(value);

      // 返回单行格式
      return `${key}: ${formattedValue}`;
    })
    .join("\n"); // 使用换行符连接所有 header
}

const logRequest = (req, body) => {
  try {
    requestCount++;
    const timestamp = new Date().toISOString();
    // 新增：获取文件名用的格式化时间戳
    const requestTimestamp = getFormattedTimestamp();
    const shortRequestId = generateShortId(); // 生成8位短ID（替代UUID）
    const requestId = `${requestTimestamp}_${requestCount}_${shortRequestId}`;

    // const logData = {
    //   requestId: requestId,
    //   timestamp,
    //   method: req.method,
    //   url: req.url,
    //   headers: req.headers,
    //   body: body,
    // };

    const logData = `
[${timestamp}]${requestId}

${req.method} ${req.url}

${formatHeadersToText(req.headers)}

${JSON.stringify(body, null, 2)}
`;

    console.log("\n========== 入参 ==========");
    console.log(`[${requestId}]# ${req.method} ${req.url}`);
    console.log("Headers:", JSON.stringify(req.headers, null, 2));
    if (body) {
      console.log("Body:", JSON.stringify(body, null, 2).length);
      // console.log("Body:", JSON.stringify(body, null, 2));
    }
    console.log("===========================\n");

    const logFile = path.join(logsDir, `${requestId}-request.json`);
    fs.writeFileSync(logFile, logData);

    return requestId;
  } catch (error) {
    console.error(error);
  }
};

const logResponse = (requestId, statusCode, headers, body) => {
  try {
    if (body) {
      try {
        const parsed = JSON.parse(body);
        body = JSON.stringify(parsed, null, 2);
      } catch {
        // console.log("Body:", body);
      }
    }
    const timestamp = new Date().toISOString();

    const logData = `
[${timestamp}]${requestId}

${statusCode}

${formatHeadersToText(headers)}

${body}
`;

    console.log("\n========== 出参 ==========");
    console.log(`[${requestId}]# Status: ${statusCode}`);
    console.log("Headers:", JSON.stringify(headers, null, 2));
    console.log("Body:", body);
    console.log("===========================\n");

    const logFile = path.join(logsDir, `${requestId}-response.json`);
    fs.writeFileSync(logFile, logData);
  } catch (error) {
    console.error(error);
  }
};

app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ extended: true, limit: "50mb" }));
app.use(express.raw({ type: "*/*", limit: "50mb" }));

app.use((req, res, next) => {
  let body = null;
  if (req.body && Buffer.isBuffer(req.body)) {
    try {
      body = JSON.parse(req.body.toString());
    } catch {
      body = req.body.toString();
    }
  } else if (req.body && Object.keys(req.body).length > 0) {
    body = req.body;
  }

  req.headers.host = targetHost;
  // req.setHeader("host", targetHost)
  req.requestId = logRequest(req, body);
  next();
});

const proxy = createProxyMiddleware({
  target: TARGET_URL,
  changeOrigin: true,
  secure: true,
  // logger: console,
  on: {
    // 1. 核心错误回调：捕获代理层所有错误
    error: (err, req, res) => {
      // 打印结构化错误日志（控制台+文件）
      const errorLog = {
        requestId: req.requestId || "未知ID",
        timestamp: new Date().toISOString(),
        errorType: "proxy_error",
        errorMessage: err.message,
        errorStack: err.stack, // 错误堆栈（便于定位代码行）
        requestInfo: {
          method: req.method,
          url: req.originalUrl,
          headers: req.headers,
          body: req.body?.toString() || "无请求体",
        },
      };

      // 控制台打印（醒目红色）
      console.log("\n❌ [代理请求报错] ======================");
      console.log(`请求ID: ${errorLog.requestId}`);
      console.log(`报错时间: ${errorLog.timestamp}`);
      console.log(`错误信息: ${errorLog.errorMessage}`);
      console.log(
        `请求路径: ${errorLog.requestInfo.method} ${errorLog.requestInfo.url}`,
      );
      console.log(`错误堆栈:\n${errorLog.errorStack}`);
      console.log("========================================\n");

      // 写入错误日志文件（单独存放，便于排查）
      const errorLogDir = path.join(logsDir, "errors");
      if (!fs.existsSync(errorLogDir)) fs.mkdirSync(errorLogDir);
      const errorLogFile = path.join(
        errorLogDir,
        `${req.requestId || Date.now()}-error.json`,
      );
      fs.writeFileSync(errorLogFile, JSON.stringify(errorLog, null, 2));

      // 给客户端返回明确的错误响应
      res.status(502).json({
        code: "PROXY_ERROR",
        message: "代理请求目标服务器失败",
        requestId: req.requestId,
        detail: err.message,
        tip: "请检查目标服务器地址、认证信息或网络连接",
      });
    },
    proxyReq: (proxyReq, req, res) => {
      // 监听 proxyReq 的错误事件（如写入请求体失败）
      proxyReq.on("error", (err) => {
        console.log(
          `\n⚠️ [请求发送失败] 请求ID: ${req.requestId}，错误: ${err.message}`,
        );
      });

      if (
        req.body &&
        Object.keys(req.body).length > 0 &&
        !Buffer.isBuffer(req.body)
      ) {
        const bodyData = JSON.stringify(req.body);
        proxyReq.setHeader("Content-Type", "application/json");
        proxyReq.setHeader("Content-Length", Buffer.byteLength(bodyData));
        proxyReq.write(bodyData);
      }
    },
    proxyRes: (proxyRes, req, res) => {
      // 监听响应流错误
      proxyRes.on("error", (err) => {
        console.log(
          `\n⚠️ [响应接收失败] 请求ID: ${req.requestId}，错误: ${err.message}`,
        );
      });

      const chunks = [];
      // proxyRes.on("")
      proxyRes.on("data", (chunk) => {
        // console.log("data:", chunk);
        chunks.push(chunk);
        // res.write(chunk);
      });
      proxyRes.on("end", () => {
        const body = Buffer.concat(chunks).toString("utf8");
        logResponse(req.requestId, proxyRes.statusCode, proxyRes.headers, body);
        res.end();
      });
      // proxyRes.on("close", () => {
      //   res.end();
      // });
    },
  },
  // plugins: [simpleRequestLogger],
});

// app.use("/api", proxy);
app.use("/", proxy);

app.listen(PORT, (err) => {
  if (err) {
    console.dir(err);
    return;
  }
  console.log(`Claude 代理服务器已启动: http://localhost:${PORT}`);
  console.log(`目标地址: ${TARGET_URL}`);
  console.log(`日志目录: ${logsDir}`);
  console.log(
    "\n使用时请将 ANTHROPIC_BASE_URL 改为: http://localhost:8080/api/coding",
  );
});
