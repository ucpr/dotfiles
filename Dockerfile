FROM denoland/deno:2.4.2

WORKDIR config

COPY . .

CMD ["bash"]
