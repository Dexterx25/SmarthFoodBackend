"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.Markets = void 0;
class Markets {
    constructor(datas) {
        this.foodsListId = datas.foodsListId;
        this.user_id = datas.user_id;
        this.listFamily_member_id = datas.listFamily_member_id;
        this.days_market = datas.days_market;
        this.date_init = datas.date_init;
        this.date_finish = datas.date_finish;
        return Object.assign({}, this);
    }
}
exports.Markets = Markets;
//# sourceMappingURL=model.js.map