var express = require('express');
var router = express.Router();
var app_apis = require('../sett/appapis');

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/userreg', function(req, res,) {
    app_apis.userReg(req.body,(result)=>{
        res.send(result)
    })
})

router.post('/login', function(req, res,next) {
    app_apis.userLogin(req.body,(result)=>{
        res.send(result)
    })
  })
  router.post('/accupload', function(req, res) {
    let mimetype = '.'+ req.files.file.mimetype.split('/')[1];
    app_apis.accUpload(req.body,(result)=>{
      let image = req.files.file;
      let id = result.ops[0]._id;
      image.mv('./public/images/accuploads/'+id+mimetype,(err,done)=>{
        if (err){res.send({})}
        else{res.send({id:id})}
      })
    })
  })
  router.post('/userupdate',(req,res)=>{
    app_apis.userUpdate(req.body,(result)=>{
      res.send(result)
    })
  })
  router.post('/passupdate',(req,res)=>{
    app_apis.passUpdate(req.body,(result)=>{
      res.send(result)
    })
  })
  router.get('/myreports',(req,res)=>{
    app_apis.getReports(req.query,(result)=>{
      res.send(result)
    })
  })
  router.get('/reportdetail',(req,res)=>{
    app_apis.getRepDetail(req.query,(result)=>{
      res.send(result)
    })
  })

module.exports = router;