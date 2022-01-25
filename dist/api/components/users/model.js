"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class userModel {
    constructor(datas) {
        (this.names = datas.names),
            this.gender_id = datas.gender == 'Male' ? "1" : datas.gender == 'Female' ? "2" : '',
            (this.weight = datas.weight),
            this.height = datas.height,
            this.count_login = !datas.count_login ? "1" : datas.count_login,
            (this.date_birtday = new Date(datas.date_birtday)),
            (this.surnames = datas.surnames),
            (this.full_name = `${datas.names} ${datas.surnames ? datas.surnames : ''}`.trim()),
            (this.prefix_number = datas.prefix_number),
            (this.phone_number = datas.phone_number),
            (this.email = datas.email),
            (this.type_user_id = '1'),
            (this.avatar = datas.avatar);
        return Object.assign({}, this);
    }
}
exports.default = userModel;
//# sourceMappingURL=model.js.map