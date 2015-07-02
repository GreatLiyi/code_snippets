### 查找长时间运行的操作
db.currentOp()
db.killOp(id)
``` javascript
db.currentOp().inprog.forEach(
  function(op){
    if(op.secs_running>5) printjson(op);
  }
)
```
