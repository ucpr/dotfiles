FROM denoland/deno:2.1.3

WORKDIR config

COPY . .

CMD ["bash"]
