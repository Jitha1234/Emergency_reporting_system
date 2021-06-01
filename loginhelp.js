var db=require('./db_connection');
var objectId = require('mongodb').ObjectID


module.exports={
    agentLogin:(loginData)=>{
        return new Promise(async(resolve,reject)=>{
            let user = await db.get().collection('agent').findOne({email:loginData.email});
            if(user){
                if(user.password == loginData.pass){
                    resolve({"status":"login","userid":user._id,"name":user.name,"phone":user.phone,"email":user.email,"dep":user.dep,"place":user.place,"pass":user.password,})
                }else{
                    resolve({"status":"errpass"})
                }
            }else{
                resolve({"status":"nouser"})
            }
            
        })
    }
}