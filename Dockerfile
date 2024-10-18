FROM denoland/deno:2.0.1

WORKDIR config

COPY . .

CMD ["bash"]
