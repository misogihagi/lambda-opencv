# usuage

## 1 type

```

docker build . -t LambdaCVContainer
docker run --rm  -v "{PWD}":/var/task/output  LambdaCVContainer

```

## 2 change
./

└─dist

  ├─bin

  ├─numpy

  ...

  ├lambda_function.py    <- add your code!



## 3 compress

```
zip dist
```


## 4 deploy! 
