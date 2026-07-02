FROM denoland/deno:2.9.1

WORKDIR config

COPY . .

CMD ["bash"]
