var db=require('./db_connection');
var objectId = require('mongodb').ObjectID


module.exports={
    getReports:()=>{
        return new Promise(async(resolve,reject)=>{
            let reports=await db.get().collection('accreport').aggregate([
                {
                    "$sort":{"_id":-1}
                },
                {
                    "$match":{cops: { $nin : ["0"] }}
                },
                {
                    "$lookup": {
                        "from": "user",
                        "let": { "userObjId": { "$toObjectId": "$userid" } },
                        "pipeline": [
                            { "$match": { "$expr": { "$eq": [ "$_id", "$$userObjId" ] } }}
                        ],
                        "as": "user"
                    },
                }
            ]).toArray()
            resolve(reports)
        })
    },
    getDetail:(accid)=>{
        return new Promise(async(resolve,reject)=>{
            let iid = objectId(accid)
            let response=await db.get().collection('accreport').aggregate([
                {
                    '$match': {
                      '_id': iid
                    }
                  },
                  { "$lookup": {
                    "let": { "userObjId": { "$toObjectId": "$userid" } },
                    "from": "user",
                    "pipeline": [
                      { "$match": { "$expr": { "$eq": [ "$_id", "$$userObjId" ] } } }
                    ],
                    "as": "user"
                  }}
            ]).toArray()
            resolve(response)
        })
    },
    copView:async (accid)=>{
        let id = objectId(accid);
        db.get().collection('accreport').findOne({_id:id},function(err,result){
            if(result.cops === '1'){
                db.get().collection('accreport').updateOne({_id:id}, {$set: {'cops':'10'}});
            }else{}
        });
    },
    copAccept:async (accid)=>{
        return new Promise(async(resolve,reject)=>{
            let id = objectId(accid)
            let response=await db.get().collection('accreport').updateOne({_id:id}, {$set: {'cops':'11'}})
            resolve(response)
        })
    },
}