const { response } = require('express');
var express = require('express');
var router = express.Router();
const ksebFitch = require('../sett/ksebFitch')

/* GET users listing. */

router.get('/', function(req, res) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'electrical'){
      res.render('electrical/dindex', { title: 'Dashboard', post:'Electrisity',user });
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
    if (user.dep == 'electrical'){
      let accid=req.query.id
      ksebFitch.getDetail(accid).then((response)=>{
        ksebFitch.ksebView(accid);
        console.log(response)
        res.render('electrical/report_detail', { title: 'Accident Details', response, post:'Electrisity',user });
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
    if (user.dep == 'electrical'){
      let accid=req.query.id
      ksebFitch.ksebAccept(accid).then((response)=>{
        res.redirect('/electrical/reports');
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
    if (user.dep == 'electrical'){
      ksebFitch.getReports().then((reports)=>{
        res.render('electrical/reports', { title: 'Reports', reports, post:'Electrisity',user });
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
    if (user.dep == 'electrical'){
      ksebFitch.getReports().then((reports)=>{
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
