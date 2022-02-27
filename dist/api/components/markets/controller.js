"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("../../../utils/actions/personas/index");
const auth = __importStar(require("../../../authorizations/index"));
const model_1 = require("./model");
function default_1(injectedStore, injectedCache) {
    let cache = injectedCache;
    let store = injectedStore;
    if (!store) {
        store = require('../../../store/dummy');
    }
    if (!cache) {
        cache = require('../../../store/dummy');
    }
    const table = 'markets';
    function insert({ datas, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                const responValidator = yield (0, index_1.Validator)(datas);
                if (responValidator) {
                    reject({ msg: responValidator });
                    return false;
                }
                const data = new model_1.FoodModel(datas);
                try {
                    const registerRespon = yield store.upsert(table, { data, type });
                    console.log('RES create Foood---', registerRespon);
                    resolve(registerRespon);
                }
                catch (e) {
                    yield (0, index_1.midlleHandleError)(e, table, datas, resolve, reject);
                }
            }));
        });
    }
    let enumFilter;
    (function (enumFilter) {
    })(enumFilter || (enumFilter = {}));
    function list({ token, filter, market_id }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                const { id } = yield auth.decodeHeader({ token });
                console.log('LIST CONTROLLER markets');
                try {
                    let foods = yield cache.list(table);
                    if (!foods) {
                        if (filter === null || filter === void 0 ? void 0 : filter.length) {
                            filter ?
                                foods = yield store.query(table, { id: market_id, user_id: id, filter }, new Array('category_foods', 'food_component', 'foods_market', 'foods_market_food_component'))
                                : foods = yield store.query(table, { id: market_id, user_id: id }, new Array('category_foods', 'food_component', 'foods_market', 'foods_market_food_component'));
                            // const categoration = query == 'dinner' ? CateoryFoodEnum[query] : query == 'lunch' ? CateoryFoodEnum[query] : query == 'breakfast' && CateoryFoodEnum[query] 
                            //  foods = await store.query(table, {category_id: categoration}, new Array('category_foods'));
                        }
                        //  !foods && reject({ msg: 'No hay platos de comida' });
                        //  cache.upsert(foods, table, '0.2');
                    }
                    else {
                        console.log('datos traidos de la cache ddddd');
                    }
                    resolve(foods);
                }
                catch (error) {
                    reject(error);
                    return false;
                }
            }));
        });
    }
    function get(data) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                try {
                    const { filter } = data;
                    const theData = { type: 'getFood', querys: filter };
                    let food = yield cache.get(filter.id, table);
                    if (!food) {
                        console.log('no estaba en cachee, buscando en db');
                        food = yield store.get(theData, table);
                    }
                    yield cache.upsert(food, table);
                    resolve(food);
                }
                catch (error) {
                    console.log('this error--->', error);
                    return reject({ msg: 'maybe the food dont exist or is not active' });
                }
            }));
        });
    }
    function update({ datas, id, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                const responValidator = yield (0, index_1.Validator)(datas);
                if (responValidator) {
                    reject({ msg: responValidator });
                    return false;
                }
                const data = Object.assign(new model_1.FoodModel(datas), { id });
                try {
                    const dataRespon = yield store.upsert(table, { data, type });
                    console.log('this is the dataRespon--->', dataRespon);
                    resolve(dataRespon);
                }
                catch (error) {
                    (0, index_1.midlleHandleError)(error, table, data, resolve, reject);
                }
            }));
        });
    }
    function remove({ id, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                try {
                    const dataRespon = yield store.remove(table, { id, type });
                    resolve(dataRespon);
                }
                catch (error) {
                    (0, index_1.midlleHandleError)(error, table, { data: id }, resolve, reject);
                }
            }));
        });
    }
    function patch({ id, type }) {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                try {
                    const data = { id, active: true };
                    const dataRespon = yield store.patch(table, { data, type });
                    resolve(dataRespon);
                }
                catch (error) {
                    (0, index_1.midlleHandleError)(error, table, { data: id }, resolve, reject);
                }
            }));
        });
    }
    return {
        insert,
        list,
        get,
        update,
        remove,
        patch
    };
}
exports.default = default_1;
//# sourceMappingURL=controller.js.map