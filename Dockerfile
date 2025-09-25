FROM denoland/deno:2.5.2

WORKDIR config

COPY . .

CMD ["bash"]
