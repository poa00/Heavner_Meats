import uvicorn

if __name__ == '__main__':
    uvicorn.run("main:app",
                host="0.0.0.0",
                port=8432,
                reload=True,
                ssl_keyfile="./localhost+2-key.pem",
                ssl_certfile="./localhost+2.pem"
                )
