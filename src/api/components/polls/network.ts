/* eslint-disable prefer-const */
import { Router, Request, Response, NextFunction } from 'express';
import controller from './index';
const {
  ServerResponse,
  ConsoleResponse
} = require('../../../utils/responses/index');
import secure from './secure';
const router: Router = Router();

import multer from 'multer';
import mimeTypes from 'mime-types';

const storage = multer.diskStorage({
  destination: 'public/photos',
  filename: function (req: Request, file: any, cb: any) {
    cb('', Date.now() + '.' + file.originalname);
  }
});

const upload = multer({
  storage: storage
});

router.post('/', upload.single('file'), secure('upsert'), upsert);
router.get('/:id', get);
router.get('/', secure('list'), list);
router.put('/:id', secure('update'), update);
router.delete('/:id', secure('delete'), remove);
router.patch('/:id/active', secure('active'), patch);
router.get('/filter/one', filter)
let procedence = 'POLL NETWORK';

async function upsert(req: Request, res: Response, next: NextFunction) {
  console.log('This IS The File:', req.files);

  const datas: Record<string, unknown> = {
    type: 'poll_register',
    datas: req.body,
    files: req.files,
    token: req.headers.authorization
  };
  console.log('UPSERTTTTT');
  console.log('body--->', datas);
  await controller
    .insert(datas)
    .then((respon: any) => {
      ConsoleResponse.success(procedence, respon);
      ServerResponse.success(req, res, respon, 201);
    })
    .catch((err) => {
      ServerResponse.error(req, res, err);
    });
}

async function get(req: Request, res: Response, next: NextFunction) {
  const data = {
    filter: req.params,
    token: req.headers.authorization
  };
  console.log('datass noo-->', data);

  await controller
    .get(data)
    .then((dataFood: any) => {
      ConsoleResponse.success(procedence, dataFood);
      ServerResponse.success(req, res, dataFood, 200);
    })
    .catch((err) => {
      console.log('this is the error--°', err);
      ServerResponse.error(req, res, err, 400);
    });
}
async function filter(req: Request, res: Response, next: NextFunction) {
  const data = {
    filter: req.query,
    token: req.headers.authorization
  };
  console.log('datass filter xdd-->', data);

  await controller
    .get(data)
    .then((dataFood: any) => {
      ConsoleResponse.success(procedence, dataFood);
      ServerResponse.success(req, res, dataFood, 200);
    })
    .catch((err) => {
      console.log('this is the error--°', err);
      ServerResponse.error(req, res, err, 400);
    });
}
async function list(req: Request, res: Response, next: NextFunction) {
  
  await controller
    .list()
    .then((respon) => {
      ServerResponse.success(req, res, respon, 200);
    })
    .catch((err) => {
      ServerResponse.error(req, res, err);
    });
}

async function update(req: Request, res: Response, next: NextFunction) {
  const data = {
    id: req.params.id || req.params._id,
    datas: req.body,
    type: 'food_update'
  };

  await controller
    .update(data)
    .then((datasAlter) => {
      ServerResponse.success(req, res, datasAlter, 200);
    })

    .catch((err) => {
      ServerResponse.error(req, res, err);
    });
}

async function patch(req: Request, res: Response, next: NextFunction) {
  const data = {
    id: req.params.id,
    type: 'food_patch_active'
  };

  await controller
    .patch(data)
    .then((datasAlter) => {
      ServerResponse.success(req, res, datasAlter, 202);
    })

    .catch((err) => {
      ServerResponse.error(req, res, err);
    });
}

async function remove(req: Request, res: Response, next: NextFunction) {
  const data = {
    id: req.params.id,
    type: 'food_delete'
  };

  await controller
    .remove(data)
    .then((datasAlter) => {
      ServerResponse.success(req, res, datasAlter, 202);
    })

    .catch((err) => {
      ServerResponse.error(req, res, err);
    });
}

export default router;
