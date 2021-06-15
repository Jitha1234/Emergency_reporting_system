const { response } = require('express');
var express = require('express');
var router = express.Router();
const ambFitch = require('../sett/ambulanceFitch')

/* GET users listing. */

router.get('/', function(req, res) {
  let user = req.session.user;
  if(req.session.loggedIn){
    if (user.dep == 'ambulance'){
      res.render('ambulance/dindex', { title: 'Dashboard', post:'Ambulance Services',user });
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
    if (user.dep == 'ambulance'){
      let accid=req.query.id
      ambFitch.getDetail(accid).then((response)=>{
        ambFitch.ambView(accid);
        console.log(response)
        res.render('ambulance/report_detail', { title: 'Accident Details', response, post:'Ambulance Services',user });
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
    if (user.dep == 'ambulance'){
      let accid=req.query.id
      ambFitch.ambAccept(accid).then((response)=>{
        console.log(response)
        res.redirect('/ambulance/reports');
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
    if (user.dep == 'ambulance'){
      ambFitch.getReports().then((reports)=>{
        console.log(reports)
        res.render('ambulance/reports', { title: 'Reports', reports, post:'Ambulance Services',user });
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
    if (user.dep == 'ambulance'){
      ambFitch.getReports().then((reports)=>{
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
