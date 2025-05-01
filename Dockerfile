FROM denoland/deno:2.3.1

WORKDIR config

COPY . .

CMD ["bash"]
