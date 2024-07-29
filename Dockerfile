FROM denoland/deno:1.45.4

WORKDIR config

COPY . .

CMD ["bash"]
