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
exports.sendMQTTMessage = void 0;
const network_1 = __importDefault(require("./network"));
const index_1 = require("../../../MSV_Requests/index");
function sendMQTTMessage({ message, user_id, topic }) {
    return new Promise((resolve, reject) => __awaiter(this, void 0, void 0, function* () {
        let data;
        if (!message) {
            const curiousCatFact = yield (0, index_1.getCuriousFact)();
            data = { message: [curiousCatFact], user: [user_id] };
        }
        else {
            data = { message: [message], user: [user_id] };
        }
        console.log('this is the data to publish-->', data);
        network_1.default.publish(topic, JSON.stringify(data), function (error) {
            if (error) {
                reject({ msg: error, statusCode: 400 });
            }
            else {
                resolve('MQTT Message succefull send');
            }
        });
    }));
}
exports.sendMQTTMessage = sendMQTTMessage;
//# sourceMappingURL=controller.js.map