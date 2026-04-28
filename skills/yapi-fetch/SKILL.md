---
name: yapi-fetch
description: 根据用户提供的接口路径查询 YApi 详细文档。仅在用户明确提出要使用 YApi 时触发。
context: fork
agent: Explore
permissions: WebFetch,Fetch,Read,Bash
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

## 接口调用权限
- **如果遇到 WebFetch 工具没权限，可以使用 Bash 执行 curl 命令进行请求

## 获取接口数据（有详细接口数据定义文档）

### 基本信息

**Path：** /api/interface/get  
**Method：** GET  
**接口描述：**

### 请求参数

#### Headers

| 参数名称     | 参数值           | 是否必须 | 示例 | 备注 |
| ------------ | ---------------- | -------- | ---- | ---- |
| Content-Type | application/json | 是       |      |      |

#### Query

| 参数名称 | 是否必须 | 示例 | 备注   |
| -------- | -------- | ---- | ------ |
| id       | 是       |      | 接口id |
| token    | 是       |      |        |

### 返回数据

| 名称                       | 类型      | 是否必须 | 默认值 | 备注                       | 其他信息            |
| -------------------------- | --------- | -------- | ------ | -------------------------- | ------------------- |
| errcode                    | number    | 非必须   |        |                            |                     |
| errmsg                     | string    | 非必须   |        |                            |                     |
| data                       | object    | 非必须   |        |                            |                     |
| ├─ \_id                    | number    | 非必须   |        | 接口id                     |                     |
| ├─ project_id              | number    | 非必须   |        | 项目id                     |                     |
| ├─ catid                   | number    | 非必须   |        | 品类id                     |                     |
| ├─ title                   | string    | 非必须   |        |                            |                     |
| ├─ path                    | string    | 非必须   |        | 请求路径                   |                     |
| ├─ method                  | string    | 非必须   |        | 请求method                 |                     |
| ├─ req_body_type           | string    | 非必须   |        | 请求数据类型               | 枚举: raw,form,json |
| ├─ res_body                | string    | 非必须   |        | 返回数据                   |                     |
| ├─ res_body_type           | string    | 非必须   |        | 返回数据类型               | 枚举: json,raw      |
| ├─ uid                     | number    | 非必须   |        | 用户uid                    |                     |
| ├─ add_time                | number    | 非必须   |        |                            |                     |
| ├─ up_time                 | number    | 非必须   |        |                            |                     |
| ├─ req_body_form           | object [] | 非必须   |        | 请求 form 参数             | item 类型: object   |
| ├─ name                    | string    | 必须     |        |                            |                     |
| ├─ type                    | string    | 必须     |        |                            |                     |
| ├─ example                 | string    | 必须     |        |                            |                     |
| ├─ desc                    | string    | 必须     |        |                            |                     |
| ├─ required                | string    | 必须     | 1      |                            | 枚举: 1,0           |
| ├─ req_params              | object [] | 非必须   |        |                            | item 类型: object   |
| ├─ name                    | string    | 必须     |        |                            |                     |
| ├─ example                 | string    | 必须     |        |                            |                     |
| ├─ desc                    | string    | 必须     |        |                            |                     |
| ├─ req_headers             | object [] | 非必须   |        |                            | item 类型: object   |
| ├─ name                    | string    | 必须     |        |                            |                     |
| ├─ type                    | string    | 必须     |        |                            |                     |
| ├─ example                 | string    | 必须     |        |                            |                     |
| ├─ desc                    | string    | 必须     |        |                            |                     |
| ├─ required                | string    | 必须     | 1      |                            | 枚举: 1,0           |
| ├─ req_query               | object [] | 非必须   |        |                            | item 类型: object   |
| ├─ name                    | string    | 必须     |        |                            |                     |
| ├─ type                    | string    | 必须     |        |                            |                     |
| ├─ example                 | string    | 必须     |        |                            |                     |
| ├─ desc                    | string    | 必须     |        |                            |                     |
| ├─ required                | string    | 必须     | 1      |                            | 枚举: 1,0           |
| ├─ status                  | string    | 非必须   |        | 接口状态                   |                     |
| ├─ edit_uid                | number    | 非必须   |        | 修改的用户uid              |                     |
| ├─ res_body_is_json_schema | boolean   | 必须     | false  | 返回数据是否为 json-schema |                     |

---

## 获取接口列表数据

### 基本信息

**Path：** /api/interface/list
**Method：** GET  
**接口描述：**

### 请求参数

#### Headers

| 参数名称     | 参数值           | 是否必须 | 示例 | 备注 |
| ------------ | ---------------- | -------- | ---- | ---- |
| Content-Type | application/json | 是       |      |      |

#### Query

| 参数名称 | 是否必须 | 示例 | 备注                                                                             |
| -------- | -------- | ---- | -------------------------------------------------------------------------------- |
| token    | 是       |      |                                                                                  |
| page     | 是       | 1    | 当前页数                                                                         |
| limit    | 是       | 10   | 每页数量，默认为10，如果不想要分页数据，可将 limit 设置为比较大的数字，比如 1000 |

### 返回数据

```json
{
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
```

yapi 服务调用例子

```
http://10.10.48.2:30001/api/interface/list?token=59cfde22eb042cd19c5a55f93bacc23e6fb78ac5264097546dbf9f830ef89a1d&page=1&limit=1000

http://10.10.48.2:30001/api/interface/get?token=59cfde22eb042cd19c5a55f93bacc23e6fb78ac5264097546dbf9f830ef89a1d&id=30998

```
