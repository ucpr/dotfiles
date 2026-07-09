FROM denoland/deno:2.9.2

WORKDIR config

COPY . .

CMD ["bash"]
