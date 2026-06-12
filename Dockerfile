FROM denoland/deno:2.8.3

WORKDIR config

COPY . .

CMD ["bash"]
