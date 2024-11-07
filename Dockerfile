FROM denoland/deno:2.0.5

WORKDIR config

COPY . .

CMD ["bash"]
