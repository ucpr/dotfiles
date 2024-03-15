FROM denoland/deno:1.41.3

WORKDIR config

COPY . .

CMD ["bash"]
