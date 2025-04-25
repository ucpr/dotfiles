FROM denoland/deno:2.2.12

WORKDIR config

COPY . .

CMD ["bash"]
