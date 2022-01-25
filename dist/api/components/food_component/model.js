"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FoodComponentModel = void 0;
class FoodComponentModel {
    constructor(datas) {
        (this.name = datas.name),
            (this.image = datas.image);
        this.gross_weight = datas.gross_weight;
        this.code = datas.code;
        this.useful_weight = datas.useful_weight;
        this.net_weight = datas.net_weight;
        this.unit_measure_home = datas.unit_measure_home;
        this.skuu = datas.skuu;
        this.category_food_component_id = datas.category_food_component_id;
        this.kalories = datas.kalories;
        this.description = datas.description;
        return Object.assign({}, this);
    }
}
exports.FoodComponentModel = FoodComponentModel;
//# sourceMappingURL=model.js.map