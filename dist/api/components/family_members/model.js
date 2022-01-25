"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FamilyMembersModel = void 0;
class FamilyMembersModel {
    constructor(datas) {
        this.list = datas.list.reduce((acc, item) => {
            if (item) {
                const { date_birtday, parent, user_id } = item;
                acc.push({
                    gender_id: item.gender == 'Male' ? 1 : item.gender == 'Female' ? 2 : '',
                    date_birtday,
                    parent,
                    user_id
                });
            }
            return acc;
        }, []);
        return Object.assign({}, this);
    }
}
exports.FamilyMembersModel = FamilyMembersModel;
//# sourceMappingURL=model.js.map