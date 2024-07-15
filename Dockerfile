FROM denoland/deno:1.45.2

WORKDIR config

COPY . .

CMD ["bash"]
