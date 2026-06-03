FROM denoland/deno:2.8.2

WORKDIR config

COPY . .

CMD ["bash"]
