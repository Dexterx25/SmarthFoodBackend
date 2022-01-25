"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class messageModel {
    constructor(datas) {
        this.message = datas.message;
        this.user_id = datas.id;
        this.topic = datas.topic ? datas.topic : '/lyatest/blanco';
        return Object.assign({}, this);
    }
}
exports.default = messageModel;
//# sourceMappingURL=model.js.map