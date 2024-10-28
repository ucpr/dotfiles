FROM denoland/deno:2.0.3

WORKDIR config

COPY . .

CMD ["bash"]
