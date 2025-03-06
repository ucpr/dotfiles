FROM denoland/deno:2.2.3

WORKDIR config

COPY . .

CMD ["bash"]
