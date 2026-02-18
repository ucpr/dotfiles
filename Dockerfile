FROM denoland/deno:2.6.10

WORKDIR config

COPY . .

CMD ["bash"]
