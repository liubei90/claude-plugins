---
name: yapi-fetch
description: 根据用户提供的接口路径查询 YApi 详细文档。仅在用户明确提出要使用 YApi 时触发。
---

# 强制执行流程控制

1. **凭证检查（优先级最高）**：
   在执行任何 yapi 网络请求之前，必须检查当前对话上下文中是否包含【yapi_token】。
   - **严禁私自生成、猜测或使用示例中的 Token。**
   - 如果上下文没有用户主动提供的 token，必须立即暂停，并使用以下话术提示用户：
     > "请提供您的 YApi Token 以继续获取接口文档（如果服务地址不是默认的 http://10.10.48.2:30001/，也请一并提供）。"

2. **输入参数**：
   - `host`: YApi 服务地址。如果用户未指定，默认使用 `http://10.10.48.2:30001/`。
   - `token`: **必填项**。禁止使用文档例子中的 Token。
   - `interface_path`: 用户想要查询的接口路径（例如 `/api/user/info`）。

## 执行步骤

1.  **第一步：获取列表**
    请求 `${host}/api/interface/list?token=${token}&page=1&limit=1000`。
2.  **第二步：路径匹配**
    在返回的 `data` 数组中，查找 `path` 字段等于 `${interface_path}` 的对象，并提取其 `_id`。
3.  **第三步：获取详情**
    请求 `${host}/api/interface/get?token=${token}&id=${_id}`。
4.  **第四步：输出结果**
    将完整的接口定义（字段、类型、备注）呈现给用户。

## 关键限制

- **禁止静默失败**：如果找不到对应的 path，请列出相似的 path 供用户选择。
- **动态交互**：如果 Token 无效（报错 errcode != 0），必须告知用户并请求新的 Token。

## 和 yapi 服务交互文档

```html
<div id="right" class="content-right">
  <h1 class="curproject-name">yapi开放 api</h1>
  <h1 id="u5f00u653eu63a5u53e3api">开放接口api</h1>
  <p></p>

  <h2
    id="u83b7u53d6u63a5u53e3u6570u636euff08u6709u8be6u7ec6u63a5u53e3u6570u636eu5b9au4e49u6587u6863uff090a3ca20id3du83b7u53d6u63a5u53e3u6570u636euff08u6709u8be6u7ec6u63a5u53e3u6570u636eu5b9au4e49u6587u6863uff093e203ca3e"
  >
    获取接口数据（有详细接口数据定义文档）
    <a id="获取接口数据（有详细接口数据定义文档）"> </a>
  </h2>
  <p></p>
  <h3 id="-9">基本信息</h3>
  <p><strong>Path：</strong> /api/interface/get</p>
  <p><strong>Method：</strong> GET</p>
  <p><strong>接口描述：</strong></p>
  <h3 id="-10">请求参数</h3>
  <p><strong>Headers</strong></p>
  <table>
    <thead>
      <tr>
        <th>参数名称</th>
        <th>参数值</th>
        <th>是否必须</th>
        <th>示例</th>
        <th>备注</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Content-Type</td>
        <td>application/json</td>
        <td>是</td>
        <td></td>
        <td></td>
      </tr>
    </tbody>
  </table>
  <p><strong>Query</strong></p>
  <table>
    <thead>
      <tr>
        <th>参数名称</th>
        <th>是否必须</th>
        <th>示例</th>
        <th>备注</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>id</td>
        <td>是</td>
        <td></td>
        <td>接口id</td>
      </tr>
      <tr>
        <td>token</td>
        <td>是</td>
        <td></td>
        <td></td>
      </tr>
    </tbody>
  </table>
  <h3 id="-11">返回数据</h3>
  <table>
    <thead class="ant-table-thead">
      <tr>
        <th key="name">名称</th>
        <th key="type">类型</th>
        <th key="required">是否必须</th>
        <th key="default">默认值</th>
        <th key="desc">备注</th>
        <th key="sub">其他信息</th>
      </tr>
    </thead>
    <tbody classname="ant-table-tbody">
      <tr key="0-0">
        <td key="0">
          <span style="padding-left: 0px"
            ><span style="color: #8c8a8a"></span> errcode</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-1">
        <td key="0">
          <span style="padding-left: 0px"
            ><span style="color: #8c8a8a"></span> errmsg</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2">
        <td key="0">
          <span style="padding-left: 0px"
            ><span style="color: #8c8a8a"></span> data</span
          >
        </td>
        <td key="1"><span>object</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-0">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> _id</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">接口id</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-1">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> project_id</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">项目id</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-2">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> catid</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">品类id</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-3">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> title</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-4">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> path</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">请求路径</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-5">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> method</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">请求method</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-6">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> req_body_type</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">请求数据类型</span></td>
        <td key="5">
          <p key="2">
            <span style='font-weight: "700"'>枚举: </span
            ><span>raw,form,json</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-7">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> res_body</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">返回数据</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-8">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> res_body_type</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">返回数据类型</span></td>
        <td key="5">
          <p key="2">
            <span style='font-weight: "700"'>枚举: </span><span>json,raw</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-9">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> uid</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">用户uid</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-10">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> add_time</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-11">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> up_time</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-12">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> req_body_form</span
          >
        </td>
        <td key="1"><span>object []</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4">
          <span style="white-space: pre-wrap">请求 form 参数</span>
        </td>
        <td key="5">
          <p key="3">
            <span style='font-weight: "700"'>item 类型: </span
            ><span>object</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-12-0">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> name</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-12-1">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> type</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-12-2">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> example</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-12-3">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> desc</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-12-4">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> required</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3">1</td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5">
          <p key="2">
            <span style='font-weight: "700"'>枚举: </span><span>1,0</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-13">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> req_params</span
          >
        </td>
        <td key="1"><span>object []</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5">
          <p key="3">
            <span style='font-weight: "700"'>item 类型: </span
            ><span>object</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-13-0">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> name</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-13-1">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> example</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-13-2">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> desc</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-14">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> req_headers</span
          >
        </td>
        <td key="1"><span>object []</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5">
          <p key="3">
            <span style='font-weight: "700"'>item 类型: </span
            ><span>object</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-14-0">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> name</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-14-1">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> type</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-14-2">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> example</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-14-3">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> desc</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-14-4">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> required</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3">1</td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5">
          <p key="2">
            <span style='font-weight: "700"'>枚举: </span><span>1,0</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-15">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> req_query</span
          >
        </td>
        <td key="1"><span>object []</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5">
          <p key="3">
            <span style='font-weight: "700"'>item 类型: </span
            ><span>object</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-15-0">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> name</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-15-1">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> type</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-15-2">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> example</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-15-3">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> desc</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-15-4">
        <td key="0">
          <span style="padding-left: 40px"
            ><span style="color: #8c8a8a">├─</span> required</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">必须</td>
        <td key="3">1</td>
        <td key="4"><span style="white-space: pre-wrap"></span></td>
        <td key="5">
          <p key="2">
            <span style='font-weight: "700"'>枚举: </span><span>1,0</span>
          </p>
        </td>
      </tr>
      <tr key="0-2-16">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> status</span
          >
        </td>
        <td key="1"><span>string</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4"><span style="white-space: pre-wrap">接口状态</span></td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-17">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span> edit_uid</span
          >
        </td>
        <td key="1"><span>number</span></td>
        <td key="2">非必须</td>
        <td key="3"></td>
        <td key="4">
          <span style="white-space: pre-wrap">修改的用户uid</span>
        </td>
        <td key="5"></td>
      </tr>
      <tr key="0-2-18">
        <td key="0">
          <span style="padding-left: 20px"
            ><span style="color: #8c8a8a">├─</span>
            res_body_is_json_schema</span
          >
        </td>
        <td key="1"><span>boolean</span></td>
        <td key="2">必须</td>
        <td key="3">false</td>
        <td key="4">
          <span style="white-space: pre-wrap">返回数据是否为 json-schema</span>
        </td>
        <td key="5"></td>
      </tr>
    </tbody>
  </table>

  <h2
    id="u83b7u53d6u63a5u53e3u5217u8868u6570u636e0a3ca20id3du83b7u53d6u63a5u53e3u5217u8868u6570u636e3e203ca3e"
  >
    获取接口列表数据 <a id="获取接口列表数据"> </a>
  </h2>
  <p></p>
  <h3 id="-20">基本信息</h3>
  <p><strong>Path：</strong> /api/interface/list</p>
  <p><strong>Method：</strong> GET</p>
  <p><strong>接口描述：</strong></p>
  <h3 id="-21">请求参数</h3>
  <p><strong>Headers</strong></p>
  <table>
    <thead>
      <tr>
        <th>参数名称</th>
        <th>参数值</th>
        <th>是否必须</th>
        <th>示例</th>
        <th>备注</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Content-Type</td>
        <td>application/json</td>
        <td>是</td>
        <td></td>
        <td></td>
      </tr>
    </tbody>
  </table>
  <p><strong>Query</strong></p>
  <table>
    <thead>
      <tr>
        <th>参数名称</th>
        <th>是否必须</th>
        <th>示例</th>
        <th>备注</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>token</td>
        <td>是</td>
        <td></td>
        <td></td>
      </tr>
      <tr>
        <td>page</td>
        <td>是</td>
        <td>1</td>
        <td>当前页数</td>
      </tr>
      <tr>
        <td>limit</td>
        <td>是</td>
        <td>10</td>
        <td>
          每页数量，默认为10，如果不想要分页数据，可将 limit
          设置为比较大的数字，比如 1000
        </td>
      </tr>
    </tbody>
  </table>
  <h3 id="-22">返回数据</h3>
  <pre><code class="language-javascript">{
   "errcode": 0,
   "errmsg": "成功！",
   "data": [
      {
         "_id": 4444,
         "project_id": 299,
         "catid": 1376,
         "title": "/api/group/del",
         "path": "/api/group/del",
         "method": "POST",
         "uid": 11,
         "add_time": 1511431246,
         "up_time": 1511751531,
         "status": "undone",
         "edit_uid": 0
      }
   ]
}
</code></pre>
</div>
```

yapi 服务调用例子

```
http://10.10.48.2:30001/api/interface/list?token=59cfde22eb042cd19c5a55f93bacc23e6fb78ac5264097546dbf9f830ef89a1d&page=1&limit=1000

http://10.10.48.2:30001/api/interface/get?token=59cfde22eb042cd19c5a55f93bacc23e6fb78ac5264097546dbf9f830ef89a1d&id=30998

```
