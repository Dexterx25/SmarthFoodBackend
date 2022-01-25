"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const index_1 = require("../../utils/actions/personas/index");
const model_1 = __importDefault(require("./model"));
const index_2 = require("../../authorizations/index");
const controller_1 = require("../../MSV_mqtt/components/publisher/controller");
function default_1(injectedStore, injectedCache) {
    let cache = injectedCache;
    let store = injectedStore;
    if (!store) {
        store = require('../../../store/dummy');
    }
    if (!cache) {
        cache = require('../../../store/dummy');
    }
    // eslint-disable-next-line prefer-const
    let table = 'messages';
    function insert({ datas, type, token }) {
        return __awaiter(this, void 0, void 0, function* () {
            const { id } = yield (0, index_2.decodeHeader)({ token });
            console.log('this is the id decoded-->', id);
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                // eslint-disable-next-line prefer-const
                let data = new model_1.default(Object.assign(datas, { id }));
                try {
                    const responChat = yield (0, controller_1.sendMQTTMessage)(data);
                    resolve(responChat);
                }
                catch (e) {
                    yield (0, index_1.midlleHandleError)(e, table, datas, resolve, reject);
                }
            }));
        });
    }
    function list() {
        return __awaiter(this, void 0, void 0, function* () {
            return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
                console.log('LIST CONTROLLER Messages');
                let messages = yield cache.list(table);
                if (!messages) {
                    messages = yield store.list(table);
                    cache.upsert(messages, table);
                }
                else {
                    console.log('datos traidos de la cache');
                }
                resolve(messages);
            }));
        });
    }
    return {
        insert,
        list
    };
}
exports.default = default_1;
//# sourceMappingURL=controller.js.map