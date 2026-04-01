FROM denoland/deno:2.7.10

WORKDIR config

COPY . .

CMD ["bash"]
