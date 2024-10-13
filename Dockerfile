FROM denoland/deno:2.0.0

WORKDIR config

COPY . .

CMD ["bash"]
