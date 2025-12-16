FROM denoland/deno:2.6.1

WORKDIR config

COPY . .

CMD ["bash"]
