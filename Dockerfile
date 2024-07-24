FROM denoland/deno:1.45.3

WORKDIR config

COPY . .

CMD ["bash"]
