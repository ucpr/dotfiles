FROM denoland/deno:2.7.2

WORKDIR config

COPY . .

CMD ["bash"]
