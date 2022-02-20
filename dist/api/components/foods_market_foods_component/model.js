"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CateoryFoodEnum = exports.FoodMarketFoodComponentReturn = exports.FoodMarketFoodComponentModel = void 0;
class FoodMarketFoodComponentModel {
    constructor(datas) {
        (this.food_component_id = datas.food_component_id),
            (this.food_market_id = datas.food_market_id);
        return Object.assign({}, this);
    }
}
exports.FoodMarketFoodComponentModel = FoodMarketFoodComponentModel;
class FoodMarketFoodComponentReturn {
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
exports.FoodMarketFoodComponentReturn = FoodMarketFoodComponentReturn;
var CateoryFoodEnum;
(function (CateoryFoodEnum) {
    CateoryFoodEnum["dinner"] = "4";
    CateoryFoodEnum["breakfast"] = "1";
    CateoryFoodEnum["lunch"] = "2";
    CateoryFoodEnum["snack"] = "3";
})(CateoryFoodEnum = exports.CateoryFoodEnum || (exports.CateoryFoodEnum = {}));
//# sourceMappingURL=model.js.map