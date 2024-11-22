FROM denoland/deno:2.1.1

WORKDIR config

COPY . .

CMD ["bash"]
