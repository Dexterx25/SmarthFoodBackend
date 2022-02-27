"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CateoryFoodEnum = exports.FoodModelReturn = exports.FoodModel = void 0;
class FoodModel {
    constructor(datas) {
        (this.name = datas.name),
            (this.amount = datas.amount)((this.picture = datas.picture))((this.description = datas.description));
        this.url = datas.url;
        this.category_id = datas.category_id;
        this.price = datas.price;
        this.kalories = datas.kalories;
        return Object.assign({}, this);
    }
}
exports.FoodModel = FoodModel;
class FoodModelReturn {
    constructor(datas) {
        (this.name = datas.name),
            (this.amount = datas.amount)((this.picture = datas.picture))((this.description = datas.description));
        this.url = datas.url;
        this.category_id = datas.category_id;
        this.price = datas.price;
        this.kalories = datas.kalories;
        return Object.assign({}, this);
    }
}
exports.FoodModelReturn = FoodModelReturn;
var CateoryFoodEnum;
(function (CateoryFoodEnum) {
    CateoryFoodEnum["dinner"] = "4";
    CateoryFoodEnum["breakfast"] = "1";
    CateoryFoodEnum["lunch"] = "2";
    CateoryFoodEnum["snack"] = "3";
})(CateoryFoodEnum = exports.CateoryFoodEnum || (exports.CateoryFoodEnum = {}));
//# sourceMappingURL=model.js.map