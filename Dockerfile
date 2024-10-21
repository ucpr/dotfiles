FROM denoland/deno:2.0.2

WORKDIR config

COPY . .

CMD ["bash"]
