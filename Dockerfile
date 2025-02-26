FROM denoland/deno:2.2.2

WORKDIR config

COPY . .

CMD ["bash"]
