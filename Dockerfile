FROM denoland/deno:2.0.4

WORKDIR config

COPY . .

CMD ["bash"]
