FROM denoland/deno:2.5.1

WORKDIR config

COPY . .

CMD ["bash"]
