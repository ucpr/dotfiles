FROM denoland/deno:2.4.1

WORKDIR config

COPY . .

CMD ["bash"]
