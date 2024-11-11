FROM denoland/deno:2.0.6

WORKDIR config

COPY . .

CMD ["bash"]
