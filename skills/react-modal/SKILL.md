---
name: react-modal
description: 根据用户提供的编辑弹窗需求创建基于 antd Modal + Form 组件的编辑弹窗. 在用户在基于 react + antd 的项目中，编写新编辑弹窗，添加和修改弹窗编辑字段时使用。
---

## 代码模板

### 编辑弹窗

```tsx
import React, { useEffect } from "react";
import { Modal, ModalProps, Form, Select } from "antd";

type IProps = Omit<ModalProps, "onOk"> & {
  detail?: any;
  onOk?: () => void;
};

const DemoModal: React.FC<IProps> = ({ onOk, detail, ...props }) => {
  const [form] = Form.useForm();

  useEffect(() => {
    if (props.open) {
      form.setFieldsValue({
        ...detail,
      });
    }
  }, [detail, props.open]);

  const onFinish = () => {
    onOk?.();
  };

  return (
    <Modal {...props} onOk={form.submit}>
      <Form form={form} onFinish={onFinish}>
        <Form.Item
          label="字段1"
          name="f1"
          rules={[{ message: "请选择字段1", required: true }]}
        >
          <Select placeholder="请选择" options={[]} />
        </Form.Item>
      </Form>
    </Modal>
  );
};

export default DemoModal;
```

### 使用编辑弹窗

```tsx
import React from "react";
import { Button } from "antd";

import useModal from "@src/util/useModal";
import DemoModal from "./components/DemoModal";

export type DemoProps = Record<string, any>;

const Demo: React.FC<DemoProps> = () => {
  const editModal = useModal("编辑");

  return (
    <>
      <div>
        <Button
          onClick={() => {
            editModal.setModalData({
              rowid: 1,
              name: "",
            });
            editModal.showModal();
          }}
        >
          编辑
        </Button>
      </div>
      <DemoModal
        detail={editModal.modalData}
        open={editModal.visible}
        onCancel={editModal.hideModal}
        onOk={() => {
          editModal.hideModal();
          // TODO: 刷新列表等操作
        }}
      />
    </>
  );
};

export default Demo;
```
