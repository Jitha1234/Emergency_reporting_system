const { response } = require('express');
var express = require('express');
var router = express.Router();
const copsFitch = require('../sett/copsFitch')

/* GET users listing. */

router.get('/', function(req, res) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'cops'){
      res.render('cops/dindex', { title: 'Dashboard', post:'Cops',user });
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/details', function(req, res,next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'cops'){
      let accid=req.query.id
  copsFitch.getDetail(accid).then((response)=>{
    copsFitch.copView(accid);
    console.log(response)
    res.render('cops/report_detail', { title: 'Accident Details', response, post:'Cops',user });
  })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/accept', function(req, res,next) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'cops'){
      let accid=req.query.id
      copsFitch.copAccept(accid).then((response)=>{
        console.log(response)
        res.redirect('/cops/reports');
      })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/reports', function(req, res,) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'cops'){
      copsFitch.getReports().then((reports)=>{
        console.log(reports)
        res.render('cops/reports', { title: 'Reports', reports, post:'Cops',user });
      })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});
router.get('/rerep', function(req, res,) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'cops'){
      copsFitch.getReports().then((reports)=>{
        console.log(reports)
        res.send(reports);
      })
    }else{
      res.redirect('/login')
    }
  }else{
    res.redirect('/login')
  }
});

module.exports = router;
