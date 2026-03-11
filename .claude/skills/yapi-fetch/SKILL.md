---
name: yapi-fetch
description: 根据用户提供的接口路径查询出 yapi 文档中对应接口详细文档，为后续写接口逻辑提供文档支持. 在用户写新需求，添加和修改接口字段，进行接口联调时使用。或者用户说出"使用xxx接口"时使用。**需要用户明确提出要使用 yapi 时才可用**
---

当用户要使用 xxx 接口时，需要从上下文中找到 yapi 的服务地址，请求 token。如果没有找到这些信息，暂停执行后续步骤，让用户先输入这些信息，才能进行后续步骤。

## 关键概念

【host】: yapi 的服务地址，默认是 http://10.10.48.2:30001/
【token】: 和 yapi 服务交互时的唯一的标识

## 和 yapi 服务交互文档

下面这是 html 格式的交互 api 文档，包含【获取接口数据】和【获取接口列表数据】两个接口。当要查询 xxx 接口的详细定义时，需要先调用 【获取接口列表数据】接口获取所有接口列表集合，然后在这个列表集合中搜索出来 path 等于 xxx 的项目，取出 id 字段作为 【获取接口数据】 接口的入参，查询出该接口的详细文档。

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
