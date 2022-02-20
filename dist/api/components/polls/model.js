"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PollModel = void 0;
class PollModel {
    constructor(datas) {
        this.times_recurral_market = datas.times_recurral_market;
        this.count_persons = datas.count_persons;
        this.sugest_snaks = datas.sugest_snaks;
        this.user_id = datas.user_id;
        this.sugest_without_dairy = datas.sugest_without_dairy;
        this.vegetarian_food = datas.vegetarian_food;
        this.type_id = datas.type_id ? datas.type_id : '1';
        return Object.assign({}, this);
    }
}
exports.PollModel = PollModel;
//# sourceMappingURL=model.js.map