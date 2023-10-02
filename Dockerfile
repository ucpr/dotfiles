FROM denoland/deno:1.37.1

WORKDIR config

COPY . .

CMD ["bash"]
