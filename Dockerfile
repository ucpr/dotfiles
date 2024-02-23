FROM denoland/deno:1.41.0

WORKDIR config

COPY . .

CMD ["bash"]
